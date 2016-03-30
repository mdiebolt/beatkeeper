window.MARGIN = 30
window.INSTRUMENT_LINE_HEIGHT = 60
window.TEMPO = 80
window.MAIN_WIDTH = window.innerWidth - 300
window.STAFF_WIDTH = MAIN_WIDTH - (2 * MARGIN)
window.STAFF_HEIGHT = 240

require("loops").create()
require("staff").create()
