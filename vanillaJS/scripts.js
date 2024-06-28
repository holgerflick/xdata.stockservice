let chart = null;

const baseUrl = 'http://192.168.4.80';

async function updateSelections() {
  const yearsResponse = await fetch(`${baseUrl}/StockService/Years`);
  const yearsJson = await yearsResponse.json();
  const years = yearsJson.value;

  const symbolResponse = await fetch(`${baseUrl}/StockService/Symbols`);
  const symbolJson = await symbolResponse.json();
  const symbols = symbolJson.value;

  const yearSelect = document.getElementById('SelectYear');
  years.forEach((year) => {
    const option = document.createElement('option');
    option.text = year;
    option.value = year;
    yearSelect.appendChild(option);
  });

  const symbolSelect = document.getElementById('SelectSymbol');
  symbols.forEach((symbol) => {
    const option = document.createElement('option');
    option.text = symbol.Name;
    option.value = symbol.Name;
    symbolSelect.appendChild(option);
  });
}

async function showChart() {
  const ctx = document.getElementById('myChart');

  const year = document.getElementById('SelectYear').value;
  const symbol = document.getElementById('SelectSymbol').value;

  let url = baseUrl + '/StockService/LineChart?Symbol=' + symbol;

  if (year !== '*') {
    url = url + '&Year=' + year;
  }

  const response = await fetch(url);

  const data = await response.json();
  if (chart !== null) {
    chart.destroy();
  }
  chart = new Chart(ctx, data);
}

// add event handler when DOM content is loaded
document.addEventListener('DOMContentLoaded', () => {
  updateSelections();
});
