import Muuri from 'muuri';

// 現在のページのURLからmypageIdを抽出する関数
function getMypageIdFromUrl() {
  const path = window.location.pathname;
  // URLパスを '/' で分割して配列にする
  const segments = path.split('/');
  // 'mypages' の次に来る部分をmypageIdとして取得
  const mypageIndex = segments.indexOf('mypages') + 1;
  if (mypageIndex > 0 && segments.length > mypageIndex) {
    const mypageId = segments[mypageIndex];
    return mypageId;
  }
  return null; // mypageIdが見つからない場合はnullを返す
}

// Muuriのグリッド
let grid;

document.addEventListener('turbo:load', () => {

  grid = new Muuri('.grid', {
    // Muuriの初期設定...
    dragEnabled: true,
  }).on('dragEnd', function (item, event) {
    // ドラッグ操作完了後に実行される
    const order = getItemsOrder(); // 新しい順序を取得
    console.log(order); // コンソールに順序を表示
    saveItemsOrder(mypageId,order);
  });
});


// この関数を使ってmypageIdを取得
const mypageId = getMypageIdFromUrl();

function getItemsOrder() {
  // アイテムを選択するためのセレクターを指定
  const items = grid.getItems();
  
  // MuuriアイテムのDOM要素からID属性を取得し、そのIDの数字部分を抽出
  const order = items.map(item => {
    const id = item.getElement().getAttribute('id');
    const matchResult = id.match(/\d+/); // IDから数字部分を抽出
    return matchResult ? matchResult[0] : null; // matchResultがnullでないことを確認
  }).filter(id => id !== null); // nullを除外して有効なIDのみを保持
  
  return order;
}

function saveItemsOrder(mypageId, order) {
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  fetch(`/mypages/${mypageId}/items/save_order`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': csrfToken
    },
    body: JSON.stringify({ order: order })
  })
  .then(response => {
    if (!response.ok) {
      throw new Error('Failed to save order');
    }
    return response.json();
  })
  .then(data => {
    console.log('Order saved:', data);
    // 必要に応じて追加の処理を行う
  })
  .catch(error => {
    console.error('Error:', error);
    // エラーを適切に処理する
  });
}

