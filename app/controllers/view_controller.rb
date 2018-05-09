require "open-uri"
require "csv"

class ViewController < ApplicationController
    def all
        url = "https://www.tadl.org/stats/data/circ-weekly.csv"
        circ_weekly = open(url).read()
        csv = CSV.parse(circ_weekly, :headers => false)
        @circ_label = []
        @circ_tc = []
        @circ_ebb = []
        @circ_flpl = []
        @circ_kbl = []
        @circ_ipl = []
        @circ_pcl = []
        csv.each do |row|
            location, date, count = row

            if location == "TADL-WOOD"
                @circ_label.push(date)
                @circ_tc.push(count)
            end
            if location == "TADL-EBB"
                @circ_ebb.push(count)
            end
            if location == "TADL-FLPL"
                @circ_flpl.push(count)
            end
            if location == "TADL-KBL"
                @circ_kbl.push(count)
            end
            if location == "TADL-IPL"
                @circ_ipl.push(count)
            end
            if location == "TADL-PCL"
                @circ_pcl.push(count)
            end

        end

        @graph1_data = {
            labels: @circ_label,
            datasets: [
                {
                    label: "Traverse City",
                    backgroundColor: "rgba(57,106,177,0.2)",
                    borderColor: "rgba(57,106,177,1)",
                    data: @circ_tc,
                    fill: 'origin',
                },
                {
                    label: "East Bay",
                    backgroundColor: "rgba(218,124,48,0.2)",
                    borderColor: "rgba(218,124,48,1)",
                    data: @circ_ebb,
                    fill: '-1',
                },
                {
                    label: "Fife Lake",
                    backgroundColor: "rgba(62,150,81,0.2)",
                    borderColor: "rgba(62,150,81,1)",
                    data: @circ_flpl,
                    fill: '-1',
                },
                {
                    label: "Kingsley",
                    backgroundColor: "rgba(204,37,41,0.2)",
                    borderColor: "rgba(204,37,41,1)",
                    data: @circ_kbl,
                    fill: '-1',
                },
                {
                    label: "Interlochen",
                    backgroundColor: "rgba(83,81,84,0.2)",
                    borderColor: "rgba(83,81,84,1)",
                    data: @circ_ipl,
                    fill: '-1',
                },
                {
                    label: "Peninsula",
                    backgroundColor: "rgba(107,76,154,0.2)",
                    borderColor: "rgba(107,76,154,1)",
                    data: @circ_pcl,
                    fill: '-1',
                },
            ]
        }

        @line_graph_options = {
            width: 1200,
            height: 480,
            plugins: {
                filler: {
                    propogate: true
                }
            },
            scales: {
                yAxes: [{
                    stacked: true
                }]
            },
            tooltips: {
                mode: 'x'
            }
        }

    end

    def eastbay
    end

    def fifelake
    end

    def interlochen
    end

    def kingsley
    end

    def peninsula
    end

    def traversecity
    end
end
