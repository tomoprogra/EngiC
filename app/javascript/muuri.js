import Muuri from 'muuri';

// Muuriのグリッド
let grid;

document.addEventListener('turbo:load', () => {

  const grid = new Muuri('.grid', {
    dragEnabled: true,
    layoutOnInit: false    
  });

  grid.refreshItems().layout();

});


const addButton = document.getElementById('add-button');

addButton.addEventListener('click', () => {
  
  // ここにアイテム追加の処理を記述
  grid.refreshItems().layout();

});


//   var sortAsc = document.querySelector('.sort-asc');
//   var sortDesc = document.querySelector('.sort-desc');

//   // Sort the items before the initial layout
//   // and do the initial layout
//   grid.sort('id', {layout: 'instant'});

//   // Bind the button event listeners
//   sortAsc.addEventListener('click', function () {
//     grid.sort('id');
//   });
//   sortDesc.addEventListener('click', function () {
//     grid.sort('id:desc');
//   });
// });
