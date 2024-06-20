async function showChart() {
  const ctx = document.getElementById('myChart');

  const response = await fetch(
    'http://192.168.4.71/StockService/LineChart?Symbol=AAPL'
  );

  let data = await response.json();

  new Chart(ctx, data);
}

// add event handler when DOM content is loaded
document.addEventListener('DOMContentLoaded', () => {
  showChart();
});
