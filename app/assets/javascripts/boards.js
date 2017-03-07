$(document).on('turbolinks:load', function () {
	$('.new_link').on('ajax:success', function (event, data, status, xhr) {
    addUrlToList(data.url)
  });

  $('.new_link').on('ajax:error', function (event, xhr, status, error) {
    console.log('Error')
  });

  $('.link-drop-zone').on({
    'dragover dragenter': function (event) {
      event.preventDefault()
      event.stopPropagation()
    },

    'drop': function (event) {
      event.preventDefault()

      var link = extractLinkText(event)

      if (!link) {
        console.log('No link')
      } else {
        console.log('Dropped link ', link)
        $('.link-drop-zone-text')
          .text(link)
          .addClass('main-font-color')
      }

    }
  })

  initiateServerEventListener()
})

function extractLinkText (event) {
  var dataTransfer = event.originalEvent.dataTransfer
  return dataTransfer.getData('text/uri-list')
}

function initiateServerEventListener () {
  var id = getBoardId()
  var source = new EventSource(Routes.board_links_path(id))
  source.addEventListener('newlink', function (event) {
    console.log(event.data)
  })
}

function getBoardId () {
  var title = document.querySelector('.board-title')
  return title.dataset.boardId
}

function addUrlToList (url) {
  var list = getListElement()
  var link = createListItem(url)
  list.appendChild(link)
}

function getListElement () {
  return document.querySelector('.link-list')
}

function createListItem (contents) {
  var link = document.createElement('li')
  link.innerHTML = contents

  return link
}
