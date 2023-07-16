setTimeout(function(){
  $('.content-wrapper h2, .content-wrapper h3, .content-wrapper h4').append('<a href=""><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.775 3.275a.75.75 0 001.06 1.06l1.25-1.25a2 2 0 112.83 2.83l-2.5 2.5a2 2 0 01-2.83 0 .75.75 0 00-1.06 1.06 3.5 3.5 0 004.95 0l2.5-2.5a3.5 3.5 0 00-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 010-2.83l2.5-2.5a2 2 0 012.83 0 .75.75 0 001.06-1.06 3.5 3.5 0 00-4.95 0l-2.5 2.5a3.5 3.5 0 004.95 4.95l1.25-1.25a.75.75 0 00-1.06-1.06l-1.25 1.25a2 2 0 01-2.83 0z"></path></svg></a>');

  $('.content-wrapper h2, .content-wrapper h3, .content-wrapper h4').each(function(){
    let itemHref = '#' + $(this).attr('id');
    $(this).find('a').attr("href", itemHref);
  })

  $('.content-wrapper table').each(function() {
    $(this).wrap('<div class="table-wrap"></div>')
    $('.table-wrap').each(function() {
      if ($(this).find('table').width() > $(this).width()){
        $(this).css('max-width', '100%');
        $(this).css('overflow-x', 'scroll');
      }
    })
  })

  function copyToClipboard(text) {
    let sampleTextarea = document.createElement("textarea");
    document.body.appendChild(sampleTextarea);
    sampleTextarea.value = text;
    sampleTextarea.select();
    document.execCommand("copy");
    document.body.removeChild(sampleTextarea);
  }

  $('.content-wrapper h2 a, .content-wrapper h3 a, .content-wrapper h4 a').on('click', function(){
    setTimeout(function(){
      copyToClipboard($(location).attr("href"));
    }, 500);
  });

  $('.content-wrapper .note td.icon').append('<img src="https://github.com/killbill/killbill-docs/raw/v3/userguide/assets/img/note-icon.png">');

  $('.content pre').parent('.content').prepend('<div class="copy-icon"><p>API client libraries</p><svg width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8 3a1 1 0 0 1 1-1h2a1 1 0 1 1 0 2H9a1 1 0 0 1-1-1Z" fill="#78AECD"/><path d="M6 3a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2 3 3 0 0 1-3 3H9a3 3 0 0 1-3-3Z" fill="#78AECD"/></svg></div>');

  $('.copy-icon svg').on('click', function () {
    copyToClipboard($(this).parent().next().find('code').text());
  });
}, 1000);

$('.main-wrapper').css('display', 'none');
setTimeout(function() {
  $('.main-wrapper').css('display', 'block');
}, 100)

$('.main').append('<div class="lightbox-modal"> <div id="close-ligtbox">âœ•</div> <div class="img"><img src="" alt=""></div></div><div class="overlay"></div>');

$('.main img').on('click', function () {
  let path = $(this).attr('src');
  $('.lightbox-modal img').attr('src', path);
  $('.lightbox-modal, .overlay').show();
});

$('#close-ligtbox, .overlay').on('click',function () {
  $('.lightbox-modal, .overlay').hide();
});

$('.sidebar-toggler').on('click', function () {
  $(this).toggleClass('active');
  $('main.main').toggleClass('sidebar-hide');
});

$('.content-wrapper a').filter(function() {
  return this.hostname && this.hostname !== location.hostname;
}).each(function() {
  $(this).attr({
    target: '_blank',
    title: 'Visit ' + this.href + ' (click to open in a new window)'
  });
});

let toggle = $('#theme-toggle');
let currentTheme = localStorage.getItem('theme');
$('body').attr('data-theme', currentTheme);
if(currentTheme === 'dark') {
  $('#logo').attr('src', '/images/logo/dark-logo.svg');
  toggle.prop('checked', true);
}
$('.switch').on('click', function () {
  let isChecked = !toggle[0].checked;
  toggle.prop('checked', isChecked);
  if (isChecked) {
    $('body').attr('data-theme', 'dark');
    $('#logo').attr('src', '../stylesheets/images/logo/dark-logo.svg');
    localStorage.setItem('theme', 'dark');
  } else {
    $('body').attr('data-theme', 'light');
    $('#logo').attr('src', '../stylesheets/images/logo/light-logo.svg');
    localStorage.setItem('theme', 'light');
  }
});