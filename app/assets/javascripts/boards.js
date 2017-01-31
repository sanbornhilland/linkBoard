$(document).on('turbolinks:load', function () {
	$('.new_link').on('ajax:success', function (event, data, status, xhr) {
    addUrlToList(data.url);
  });

  $('.new_link').on('ajax:error', function (event, xhr, status, error) {
    console.log('Error');
  });
});

function addUrlToList (url) {
  var list = getListElement();
  var link = createListItem(url);
  list.appendChild(link);
}

function getListElement () {
  return document.querySelector('.link-list');
}

function createListItem (contents) {
  var link = document.createElement('li');
  link.innerHTML = contents;

  return link;
}