setTimeout(function () {
  $(document).ready(function () {
    $('.loader-wrapper').hide()
  })
  $('.content-wrapper h2, .content-wrapper h3, .content-wrapper h4').append('<a href=""><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.775 3.275a.75.75 0 001.06 1.06l1.25-1.25a2 2 0 112.83 2.83l-2.5 2.5a2 2 0 01-2.83 0 .75.75 0 00-1.06 1.06 3.5 3.5 0 004.95 0l2.5-2.5a3.5 3.5 0 00-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 010-2.83l2.5-2.5a2 2 0 012.83 0 .75.75 0 001.06-1.06 3.5 3.5 0 00-4.95 0l-2.5 2.5a3.5 3.5 0 004.95 4.95l1.25-1.25a.75.75 0 00-1.06-1.06l-1.25 1.25a2 2 0 01-2.83 0z"></path></svg></a>');

  $('.content-wrapper h2, .content-wrapper h3, .content-wrapper h4').each(function () {
    let itemHref = '#' + $(this).attr('id');
    $(this).find('a').attr("href", itemHref);
  })

  $('.content-wrapper table').each(function () {
    $(this).wrap('<div class="table-wrap"></div>')
    $('.table-wrap').each(function () {
      if ($(this).find('table').width() > $(this).width()) {
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

  $('.content-wrapper h2 a, .content-wrapper h3 a, .content-wrapper h4 a').on('click', function () {
    setTimeout(function () {
      copyToClipboard($(location).attr("href"));
    }, 500);
  });

  $('.content-wrapper .note td.icon').append(`<svg class="info-icon" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"> <path d="M9.99984 13.3334V10.0001M9.99984 6.66675H10.0082M18.3332 10.0001C18.3332 14.6025 14.6022 18.3334 9.99984 18.3334C5.39746 18.3334 1.6665 14.6025 1.6665 10.0001C1.6665 5.39771 5.39746 1.66675 9.99984 1.66675C14.6022 1.66675 18.3332 5.39771 18.3332 10.0001Z" stroke="#2970FF" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round"/></svg>`);

  $('.content pre').parent('.content').prepend('<div class="copy-icon"><p></p><div class="copy-icon-container"><svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.0835 1.5H11.0002C12.867 1.5 13.8004 1.5 14.5135 1.86331C15.1407 2.18289 15.6506 2.69282 15.9702 3.32003C16.3335 4.03307 16.3335 4.96649 16.3335 6.83333V12.75M4.00016 16.5H10.7502C11.6836 16.5 12.1503 16.5 12.5068 16.3183C12.8204 16.1586 13.0754 15.9036 13.2352 15.59C13.4168 15.2335 13.4168 14.7668 13.4168 13.8333V7.08333C13.4168 6.14991 13.4168 5.6832 13.2352 5.32668C13.0754 5.01308 12.8204 4.75811 12.5068 4.59832C12.1503 4.41667 11.6836 4.41667 10.7502 4.41667H4.00016C3.06674 4.41667 2.60003 4.41667 2.24351 4.59832C1.92991 4.75811 1.67494 5.01308 1.51515 5.32668C1.3335 5.6832 1.3335 6.14991 1.3335 7.08333V13.8333C1.3335 14.7668 1.3335 15.2335 1.51515 15.59C1.67494 15.9036 1.92991 16.1586 2.24351 16.3183C2.60003 16.5 3.06674 16.5 4.00016 16.5Z" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg></div></div>');

  $('.copy-icon svg').on('click', function () {
    let that = this;
    copyToClipboard($(this).parent().parent().next().find('code').text());

    // prevents having multiple copied messages when clicking over and over again.
    if (!$(this).parent().parent()[0].innerHTML.includes('<span>Copied</span>')) {
      $(this).parent().prepend('<span>Copied</span>');
      setTimeout(function () {
        $(that).parent().find('span').remove();
      }, 2000);
    }
  });
}, 1000);

$('.main').append('<div class="lightbox-modal"> <div id="close-ligtbox">âœ•</div> <div class="img"><img src="" alt=""></div></div><div class="overlay"></div>');

$('.main img').on('click', function () {
  let path = $(this).attr('src');
  $('.lightbox-modal img').attr('src', path);
  $('.lightbox-modal, .overlay').show();
});

$('#close-ligtbox, .overlay').on('click', function () {
  $('.lightbox-modal, .overlay').hide();
});

$('.sidebar-toggler').on('click', function () {
  $(this).toggleClass('active');
  $('main.main').toggleClass('sidebar-full-width-show');
});

$('.sidebar__control').on('click', function () {
  $(this).toggleClass('active');
  $('main.main').toggleClass('sidebar-show');
});

$('.content-wrapper a').filter(function () {
  return this.hostname && this.hostname !== location.hostname;
}).each(function () {
  $(this).attr({
    target: '_blank',
    title: 'Visit ' + this.href + ' (click to open in a new window)'
  });
});

let toggle = $('#theme-toggle');
let currentTheme = localStorage.getItem('theme');
$('body').attr('data-theme', currentTheme);
if (currentTheme === 'dark') {
  $('#logo').attr('src', '../stylesheets/images/logo/dark-logo.svg');
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

$('.nav.navbar-nav.active-list').parent().toggleClass('open');

function getNavigationPaths() {
  const navLinks = Array.from($(".sidebar .navbar-nav .nav-link")).map(link => {
    return new Object({
      title: link.innerText,
      link: link.href.replace(window.location.origin, ''),
      external: !link.href.includes(window.location.origin)
    })
  });

  let currentPath = window.location;
  currentPath = currentPath.href.replace(currentPath.origin, '');

  const currentNav = navLinks.find(link => link.link.split('.').at(0).toLowerCase() === currentPath.toString().toLowerCase().split('.').at(0));
  const currentNavIndex = navLinks.indexOf(currentNav);

  const prevNav = currentNavIndex > 0 && currentPath ? navLinks[currentNavIndex - 1] : null;
  const nextNav = currentNavIndex < navLinks.length ? navLinks[currentNavIndex + 1] : null;

  return { prevNav, nextNav, navLinks, currentNav };
}

const { prevNav, nextNav, navLinks, currentNav } = getNavigationPaths();
navLinks.forEach(navLink => {
  if (navLink?.external) {
    $(`a[href='${navLink?.link}'`).toggleClass('external');
    $(`a[href='${navLink?.link}'`).attr('target', '_blank');
  }
});
if (prevNav?.link) {
  $('#prev-nav-link').attr('href', `${prevNav.link}`);
  $('#prev-navigator').text(prevNav.title);
  if (prevNav?.external) {
    $(`a[href='${prevNav?.link}'`).attr('target', '_blank');
  }
} else {
  $('#prev-nav-link').css('display', 'none');
}
if (nextNav?.link) {
  $('#next-nav-link').attr('href', `${nextNav.link}`);
  $('#next-navigator').text(nextNav.title);
  if (nextNav?.external) {
    $(`a[href='${nextNav?.link}'`).attr('target', '_blank');
    $("#next-navigator").toggleClass('external');
  }
} else {
  $('#next-nav-link').css('display', 'none');
}