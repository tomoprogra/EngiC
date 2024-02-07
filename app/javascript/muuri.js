import Muuri from 'muuri';

document.addEventListener('turbo:load', function () {
  var grid = new Muuri('.grid', {
    dragEnabled: true,
    layoutOnInit: false,
    sortData: {
      id: function (item, element) {
        return parseFloat(element.children[0].textContent);
      }
    }
  });

  // Muuriグリッドのアイテムをリフレッシュしてレイアウトを行う
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
