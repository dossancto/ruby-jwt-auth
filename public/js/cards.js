export function handleCardsClicks() {
  const cards = document.querySelectorAll('.base-card');

  cards.forEach(card => {
    if (!card) {
      return;
    }
    card.addEventListener('click', () => {
      card.classList.add('animation-end');
    })

  })
}

document.addEventListener('DOMContentLoaded', handleCardsClicks);
