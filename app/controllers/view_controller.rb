require "open-uri"
require "csv"

class ViewController < ApplicationController
    def all
        url = "https://www.tadl.org/stats/data/circ-weekly.csv"
        circ_weekly = open(url).read()
        csv = CSV.parse(circ_weekly, :headers => false)
        @circ_hash = Hash.new
        @circ_hash['TADL-WOOD'] = Array.new
        @circ_hash['TADL-EBB'] = Array.new
        @circ_hash['TADL-FLPL'] = Array.new
        @circ_hash['TADL-KBL'] = Array.new
        @circ_hash['TADL-IPL'] = Array.new
        @circ_hash['TADL-PCL'] = Array.new
        @circ_hash['circdates'] = Array.new
        csv.each do |row|
            location, date, count = row

            if location == "TADL-WOOD"
                @circ_hash['circdates'].push(date)
            end

            @circ_hash[location].push(count)

        end

        @circ_graph = {
            labels: @circ_hash['circdates'],
            datasets: [
                {
                    label: "Traverse City",
                    backgroundColor: "rgba(57,106,177,0.5)",
                    borderColor: "rgba(57,106,177,1)",
                    data: @circ_hash['TADL-WOOD'],
                    fill: 'origin',
                },
                {
                    label: "East Bay",
                    backgroundColor: "rgba(218,124,48,0.5)",
                    borderColor: "rgba(218,124,48,1)",
                    data: @circ_hash['TADL-EBB'],
                    fill: '-1',
                },
                {
                    label: "Fife Lake",
                    backgroundColor: "rgba(62,150,81,0.5)",
                    borderColor: "rgba(62,150,81,1)",
                    data: @circ_hash['TADL-FLPL'],
                    fill: '-1',
                },
                {
                    label: "Kingsley",
                    backgroundColor: "rgba(204,37,41,0.5)",
                    borderColor: "rgba(204,37,41,1)",
                    data: @circ_hash['TADL-KBL'],
                    fill: '-1',
                },
                {
                    label: "Interlochen",
                    backgroundColor: "rgba(83,81,84,0.5)",
                    borderColor: "rgba(83,81,84,1)",
                    data: @circ_hash['TADL-IPL'],
                    fill: '-1',
                },
                {
                    label: "Peninsula",
                    backgroundColor: "rgba(107,76,154,0.5)",
                    borderColor: "rgba(107,76,154,1)",
                    data: @circ_hash['TADL-PCL'],
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

        @circ_type_graph = {
            labels: ["Books", "Children's Books", "Music", "Movies", "Other"],
            datasets: [{
                data: [32, 22, 7, 27, 12],
                label: "Percent",
                backgroundColor: [
                    "rgba(57,106,177,0.5)",
                    "rgba(218,124,48,0.5)",
                    "rgba(62,150,81,0.5)",
                    "rgba(204,37,41,0.5)",
                    "rgba(107,76,154,0.5)"
                ],
                borderColor: [
                    "rgba(57,106,177,1)",
                    "rgba(218,124,48,1)",
                    "rgba(62,150,81,1)",
                    "rgba(204,37,41,1)",
                    "rgba(107,76,154,1)"
                ],
                hoverBackgroundColor: [
                    "rgba(57,106,177,1)",
                    "rgba(218,124,48,1)",
                    "rgba(62,150,81,1)",
                    "rgba(204,37,41,1)",
                    "rgba(107,76,154,1)"
                ]
            }]
        }

        @collection_dist_graph = {
            labels: ["Books", "Children's Books", "Music", "Movies", "Other"],
            datasets: [{
                data: [44, 23, 11, 8, 14],
                label: "Percent",
                backgroundColor: [
                    "rgba(57,106,177,0.5)",
                    "rgba(218,124,48,0.5)",
                    "rgba(62,150,81,0.5)",
                    "rgba(204,37,41,0.5)",
                    "rgba(107,76,154,0.5)"
                ],
                borderColor: [
                    "rgba(57,106,177,1)",
                    "rgba(218,124,48,1)",
                    "rgba(62,150,81,1)",
                    "rgba(204,37,41,1)",
                    "rgba(107,76,154,1)"
                ],
                hoverBackgroundColor: [
                    "rgba(57,106,177,1)",
                    "rgba(218,124,48,1)",
                    "rgba(62,150,81,1)",
                    "rgba(204,37,41,1)",
                    "rgba(107,76,154,1)"
                ]
            }]
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
