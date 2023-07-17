
const userCart = "cart_items"
console.log("FAZOELI")


function getPageItem() {
  const product_id = document.querySelector('#product_id').value
  const price = document.querySelector('#product_price').value
  const quantity = document.querySelector('#product_category').value

  return {
    product_id: product_id,
    price: price,
    quantity: quantity
  }
}

function isItemAdded() {
  const items = getItems()
  const item = getPageItem()

  return items.some(x => x.product_id == item.product_id);
}

export function getItems() {
  return JSON.parse(localStorage.getItem(userCart)) || []
}

function removeFromCart() {
  const items = getItems()
  const item = getPageItem()

  const newCart = items.filter((i) => i.product_id !== item.product_id);

  localStorage.setItem(userCart, JSON.stringify(newCart))
  console.log("Item removed")
}

function addToCart() {
  const items = getItems();
  const item = getPageItem()

  items.push(item)

  localStorage.setItem(userCart, JSON.stringify(items))
  console.log("Item added")
}

export function sumCart(items) {
  const prices = items.map(item => parseFloat(item.price))

  return prices.reduce((acc, value) => {
    return acc + value
  })
}

function updateButtonLabel(button) {
  const added = isItemAdded()
  console.log(added)
  console.log(button)
  button.textContent = isItemAdded() ? "Remove from cart" : "Add to cart"
}

function loadBuyContent() {
  const addtoCartButton = document.querySelector("#add_to_cart");

  if (addtoCartButton === undefined) return

  updateButtonLabel(addtoCartButton)

  addtoCartButton.addEventListener('click', () => {
    if (isItemAdded()) {
      removeFromCart()
    }
    else {
      addToCart()
    }

    updateButtonLabel(addtoCartButton)
  })


}

document.addEventListener('DOMContentLoaded', loadBuyContent);
