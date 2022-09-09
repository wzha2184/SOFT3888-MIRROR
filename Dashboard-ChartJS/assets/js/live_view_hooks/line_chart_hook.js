// assets/js/live_view_hooks/line_chart_hook.js

// Import the JS file defined in the previous section.
import RealtimeLineChart from '../line_chart'

export default {
  mounted() {
    // Initialize the graph.
    this.chart = new RealtimeLineChart(this.el)

    // Add coordinates when receiving "new point" event from LiveView.
    this.handleEvent('new-point', ({ label, value }) => {
      this.chart.addPoint(label, value)
      // console.log("test")
    })

  },
  destroyed() {
    // Properly destroy after use.
    this.chart.destroy()
  }
}