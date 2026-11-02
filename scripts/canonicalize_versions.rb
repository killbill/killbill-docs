#!/usr/bin/env ruby
# frozen_string_literal: true

# Adds search-engine signals to the version directories of the published site (gh-pages).
# Old versions (/0.8/ ... /0.24/) are static HTML that is never rebuilt from this branch,
# so the tags are written into the files themselves. update_gh-pages.sh runs this script
# on every publish; it is idempotent (a second run changes nothing).
#
# Usage: canonicalize_versions.rb <site_root> [overrides_file]
#
# For every <site_root>/<version>/**/*.html (version = 0.N):
#   - remove any existing <link rel="canonical"> and <meta name="robots">
#   - if <site_root>/latest/ has the same file (or the overrides file maps it to an
#     existing /latest/ file): add <link rel="canonical" href="https://docs.killbill.io/latest/...">
#   - otherwise, or when the /latest/ page is itself noindex (404.html):
#     add <meta name="robots" content="noindex, follow">
# For every <site_root>/latest/**/*.html with neither tag (pages not rebuilt from this
# branch): add a self canonical. Pages built from this branch already have one
# (html5/document.html.slim).
#
# Cloudflare Pages could send the same signals as HTTP headers (_headers), but it accepts
# at most 100 rules there, and a per-file mapping needs several hundred.

SITE_URL = 'https://docs.killbill.io'
VERSION_DIR = /\A0\.\d+\z/
CANONICAL_TAG = /<link\s[^>]*rel=["']?canonical["']?[^>]*>/i
ROBOTS_TAG = /<meta\s[^>]*name=["']?robots["']?[^>]*>/i
HEAD_TAG = /<head(\s[^>]*)?>/i
NOINDEX = '<meta name="robots" content="noindex, follow">'

root, overrides_file = ARGV
if root.nil? || !File.directory?(File.join(root, 'latest'))
  warn "Usage: #{$PROGRAM_NAME} <site_root> [overrides_file] (site_root must contain latest/)"
  exit 1
end

latest_dir = File.join(root, 'latest')
# page => true when the /latest/ page is indexable, false when it is noindex (e.g. 404.html)
latest_pages = Dir.glob('**/*.html', base: latest_dir).to_h do |p|
  [p, File.binread(File.join(latest_dir, p)) !~ /<meta\s[^>]*name=["']?robots["']?[^>]*noindex/i]
end

overrides = {}
if overrides_file
  File.foreach(overrides_file) do |line|
    line = line.sub(/#.*/, '').strip
    next if line.empty?

    page, target = line.split(/\s+/, 2)
    overrides[page] = target
  end
end

def latest_url(page)
  path = page.sub(%r{(\A|/)index\.html\z}, '\1').sub(/\.html\z/, '')
  "#{SITE_URL}/latest/#{path}"
end

def canonical_tag(page)
  %(<link rel="canonical" href="#{latest_url(page)}">)
end

# Returns true when the file changed.
def rewrite(file)
  html = File.binread(file)
  updated = yield(html.dup)
  return false if updated.nil? || updated == html

  File.binwrite(file, updated)
  true
end

def insert_in_head(html, tag)
  return nil unless html =~ HEAD_TAG

  html.sub(HEAD_TAG) { |m| "#{m}#{tag}" }
end

stats = Hash.new(0)
unmapped = []

Dir.children(root).select { |d| d =~ VERSION_DIR && File.directory?(File.join(root, d)) }
   .sort_by { |d| d.split('.').map(&:to_i) }.each do |version|
  version_dir = File.join(root, version)
  Dir.glob('**/*.html', base: version_dir).sort.each do |page|
    target = overrides["#{version}/#{page}"] || overrides[page] || page
    if target != 'noindex' && !latest_pages[target]
      unmapped << "#{version}/#{page}" if target == page && !latest_pages.key?(page)
      warn "canonicalize_versions: override target latest/#{target} missing for #{version}/#{page}" if target != page
      target = 'noindex'
    end
    tag = target == 'noindex' ? NOINDEX : canonical_tag(target)
    stats[target == 'noindex' ? :noindex : :canonical] += 1

    file = File.join(version_dir, page)
    changed = rewrite(file) do |html|
      # Already correct (e.g. pages of the current version, built with the template tag)
      next nil if (html.scan(CANONICAL_TAG) + html.scan(ROBOTS_TAG)) == [tag]

      cleaned = html.gsub(CANONICAL_TAG, '').gsub(ROBOTS_TAG, '')
      result = insert_in_head(cleaned, tag)
      warn "canonicalize_versions: no <head> in #{file}" if result.nil?
      result
    end
    stats[:changed] += 1 if changed
  end
end

latest_pages.each_key do |page|
  file = File.join(latest_dir, page)
  changed = rewrite(file) do |html|
    next nil if html =~ CANONICAL_TAG || html =~ ROBOTS_TAG

    insert_in_head(html, canonical_tag(page))
  end
  stats[:latest_self_canonical_added] += 1 if changed
end

puts "canonicalize_versions: canonical=#{stats[:canonical]} noindex=#{stats[:noindex]} " \
     "files_changed=#{stats[:changed]} latest_self_canonical_added=#{stats[:latest_self_canonical_added]}"
puts "canonicalize_versions: noindex (no /latest/ equivalent, not in overrides): #{unmapped.join(' ')}" unless unmapped.empty?
