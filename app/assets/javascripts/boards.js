$(document).on('turbolinks:load', function () {
	$('.new_link').on('ajax:success', function (event, data, status, xhr) {
    addUrlToList(data.url);
  });

  $('.new_link').on('ajax:error', function (event, xhr, status, error) {
    console.log('Error');
  });

  initiateServerEventListener();
});

function initiateServerEventListener () {
  var id = getBoardId();
  var source = new EventSource(Routes.board_links_path(id));
  source.addEventListener('newlink', function (event) {
    console.log(event.data);
  });
}

function getBoardId () {
  var title = document.querySelector('.board-title');
  return title.dataset.boardId;
}

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
