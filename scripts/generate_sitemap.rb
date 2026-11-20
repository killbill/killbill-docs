#!/usr/bin/env ruby
# frozen_string_literal: true

# Generates sitemap.xml for the pages built by make.sh. Only /latest/ URLs are listed:
# old version directories are not in the sitemap (they point to /latest/ with a canonical
# link, see canonicalize_versions.rb).
#
# Usage: generate_sitemap.rb <built_html_dir> <userguide_dir> <output_file> [base_url]
#
# - One <url> per top-level *.html file in <built_html_dir>.
# - Pages with <meta name="robots" content="...noindex..."> (such as the 404 page) are skipped.
# - URLs are extensionless because Cloudflare Pages redirects /latest/page.html to /latest/page.
# - <lastmod> is the date of the last commit touching the page source or one of its includes.
#   It is omitted in a shallow clone, where every file would get the date of the last commit.

require 'cgi'
require 'open3'

html_dir, src_dir, output, base_url = ARGV
if html_dir.nil? || src_dir.nil? || output.nil?
  warn "Usage: #{$PROGRAM_NAME} <built_html_dir> <userguide_dir> <output_file> [base_url]"
  exit 1
end
base_url ||= 'https://docs.killbill.io/latest/'
base_url += '/' unless base_url.end_with?('/')

# Same selection as make.sh: userguide/*.adoc and userguide/*/*.adoc
sources = Dir.glob(File.join(src_dir, '*.adoc')) + Dir.glob(File.join(src_dir, '*', '*.adoc'))
source_by_name = sources.group_by { |f| File.basename(f, '.adoc') }

def git(*args)
  out, _err, status = Open3.capture3('git', *args)
  status.success? ? out.strip : nil
end

shallow = git('-C', src_dir, 'rev-parse', '--is-shallow-repository')
use_git_dates = !shallow.nil? && shallow != 'true'
warn 'generate_sitemap: shallow or missing git history, <lastmod> omitted' unless use_git_dates

# Source file plus the files it includes, recursively (paths with unknown attributes are ignored).
def with_includes(file, src_dir, seen = {})
  return [] if seen[file] || !File.file?(file)

  seen[file] = true
  File.foreach(file, encoding: 'UTF-8').flat_map do |line|
    next [] unless (m = line.scrub.match(/^include::([^\[]+)\[/))

    path = m[1].strip.gsub('{sourcedir}', src_dir)
    next [] if path.include?('{') || path.start_with?('http')

    path = File.expand_path(path, File.dirname(file))
    with_includes(path, src_dir, seen)
  end.unshift(file)
end

entries = Dir.glob(File.join(html_dir, '*.html')).sort.filter_map do |html_file|
  head = File.binread(html_file, 200_000)
  next if head =~ /<meta\s+name=["']robots["'][^>]*noindex/i

  name = File.basename(html_file, '.html')
  loc = base_url + (name == 'index' ? '' : name)

  lastmod = nil
  if use_git_dates && (srcs = source_by_name[name])
    files = srcs.flat_map { |s| with_includes(File.expand_path(s), File.expand_path(src_dir)) }.uniq
    lastmod = git('-C', src_dir, 'log', '-1', '--format=%cs', '--', *files)
    lastmod = nil if lastmod&.empty?
  end
  [loc, lastmod]
end

xml = +%(<?xml version="1.0" encoding="UTF-8"?>\n)
xml << %(<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n)
entries.each do |loc, lastmod|
  xml << "  <url>\n    <loc>#{CGI.escapeHTML(loc)}</loc>\n"
  xml << "    <lastmod>#{lastmod}</lastmod>\n" if lastmod
  xml << "  </url>\n"
end
xml << "</urlset>\n"

File.write(output, xml)
puts "generate_sitemap: #{entries.size} URLs written to #{output}"
