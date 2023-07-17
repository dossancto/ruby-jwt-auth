import { handleCardsClicks } from './cards.js'

let flashContainer = document.querySelector('.card-hold')

function getFlashType(element) {
  return element.getAttribute('flash-type') ?? "info";
}

function getFlashMessage(element) {
  const msg = element.getAttribute('flash-message')

  if (msg)
    return msg

  console.error(`Cant find "flash-message" attribute in  `, element)
  return null
}

function createFlash(type, message) {
  return `
  <div class="base-card card-${type}">
    ${message}
  </div>
  `
}

function runFlash(e) {
  const elemenet = e.srcElement

  const type = getFlashType(elemenet)
  const message = getFlashMessage(elemenet)

  if (!message) return

  const flash = createFlash(type, message)
  flashContainer.insertAdjacentHTML('beforeend', flash);
  handleCardsClicks()
}

function loadFlashActions() {
  const actions = document.querySelectorAll("*[flash-action]")
  flashContainer = document.querySelector('.card-hold')

  actions.forEach(action => {
    action.addEventListener('click', runFlash)
  })
}

document.addEventListener('DOMContentLoaded', loadFlashActions);
