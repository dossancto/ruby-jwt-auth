function handleCardsClicks() {
  const card = document.querySelector('.base-card');

  if (!card) {

    return;
  }

  card.addEventListener('click', function(e) {
    console.log(card)
    card.classList.add('animation-end');
    console.log("corinthians")
  })
}

handleCardsClicks()
