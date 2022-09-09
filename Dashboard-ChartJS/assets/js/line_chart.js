// assets/js/line_chart.js

// https://www.chartjs.org/docs/3.6.1/getting-started/integration.html#bundlers-webpack-rollup-etc
import Chart from 'chart.js/auto'
import 'chartjs-adapter-luxon'
import ChartStreaming from 'chartjs-plugin-streaming'
Chart.register(ChartStreaming)

// A wrapper of Chart.js that configures the realtime line chart.
export default class {
  constructor(ctx) {
    this.colors = [
      'rgba(255, 99, 132, 1)',
      'rgba(54, 162, 235, 1)',
      'rgba(255, 206, 86, 1)',
      'rgba(75, 192, 192, 1)',
      'rgba(153, 102, 255, 1)',
      'rgba(255, 159, 64, 1)'
    ]

    const config = {
      type: 'line',
      data: { datasets: [] },
      options: {
        datasets: {
          // https://www.chartjs.org/docs/3.6.0/charts/line.html#dataset-properties
          line: {
            // Make the line chart round.
            tension: 0.3
          }
        },
        plugins: {
          // https://nagix.github.io/chartjs-plugin-streaming/2.0.0/guide/options.html
          streaming: {
            // Specifies the width of the displayed X-axis in milliseconds.
            duration: 60 * 1000,
            // Give Chart.js time to draw the points.
            delay: 1500
          }
        },
        scales: {
          x: {
            // A type that uses the chartjs-plugin-streaming plugin functionality.
            type: 'realtime'
          },
          y: {
            // If you tell Chart.js the range of the Y-axis ahead of time, the chart will update smoothly.
            suggestedMin: 50,
            suggestedMax: 200
          }
        }
      }
    }

    this.chart = new Chart(ctx, config)
  }

  addPoint(label, value) {
    const dataset = this._findDataset(label) || this._createDataset(label)
    dataset.data.push({x: Date.now(), y: value})
    this.chart.update()
  }

  destroy() {
    this.chart.destroy()
  }

  _findDataset(label) {
    return this.chart.data.datasets.find((dataset) => dataset.label === label)
  }

  _createDataset(label) {
    const newDataset = {label, data: [], borderColor: this.colors.pop()}
    this.chart.data.datasets.push(newDataset)
    return newDataset
  }
}