import { getItems, sumCart } from './cart.js';

function createCard(item) {
  return `
    <div class="bg-white rounded-lg shadow-md p-4">
      <h2 class="text-xl font-semibold">${item.name}</h2>
      <p class="text-gray-600">$${item.price}</p>
    </div>
  `;
}

async function getProducts(product_ids) {
  const options = {
    headers: {
      'Content-Type': 'application/json',
    },
    method: "POST",
    body: JSON.stringify(product_ids)
  }

  const response = await fetch("/product/get-card-items", options)
  const products = (await response.json()).data

  return products
}

function setSubTotalText(subtotal){
  const txt = document.querySelector("#cart_subtotal")

  if(!txt) return

  txt.textContent = `Subtotal: R$${subtotal}`
}

async function renderCards() {
  const cardsContainer = document.getElementById('cards-container');
  if (cardsContainer == undefined) return

  const items = getItems() || []

  const product_ids = items.map(item => item.product_id)
  const products = await getProducts(product_ids)

  const subtotal = sumCart(products)
  setSubTotalText(subtotal)

  products.forEach((item) => {
    const cardHTML = createCard(item);
    cardsContainer.insertAdjacentHTML('beforeend', cardHTML);
  });
}

document.addEventListener('DOMContentLoaded', async () => await renderCards());
