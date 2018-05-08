class ViewController < ApplicationController
    def all
        @graph1_data = {
            labels: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
            datasets: [
                {
                    label: "Traverse City",
                    backgroundColor: "rgba(57,106,177,0.2)",
                    borderColor: "rgba(57,106,177,1)",
                    data: [81, 95, 74, 79, 85, 88, 97, 83, 90, 77, 68, 83],
                    fill: 'origin',
                },
                {
                    label: "East Bay",
                    backgroundColor: "rgba(218,124,48,0.2)",
                    borderColor: "rgba(218,124,48,1)",
                    data: [14, 18, 21, 17, 23, 24, 29, 19, 22, 11, 9, 16],
                    fill: '-1',
                },
                {
                    label: "Fife Lake",
                    backgroundColor: "rgba(62,150,81,0.2)",
                    borderColor: "rgba(62,150,81,1)",
                    data: [12, 28, 28, 12, 20, 21, 22, 29, 13, 17, 12, 10],
                    fill: '-1',
                },
                {
                    label: "Kingsley",
                    backgroundColor: "rgba(204,37,41,0.2)",
                    borderColor: "rgba(204,37,41,1)",
                    data: [24, 28, 21, 27, 33, 34, 39, 29, 32, 21, 19, 26],
                    fill: '-1',
                },
                {
                    label: "Interlochen",
                    backgroundColor: "rgba(83,81,84,0.2)",
                    borderColor: "rgba(83,81,84,1)",
                    data: [14, 18, 21, 17, 23, 24, 29, 19, 22, 11, 9, 16],
                    fill: '-1',
                },
                {
                    label: "Peninsula",
                    backgroundColor: "rgba(107,76,154,0.2)",
                    borderColor: "rgba(107,76,154,1)",
                    data: [14, 18, 21, 17, 23, 24, 29, 19, 22, 11, 9, 16],
                    fill: '-1',
                },
            ]
        }

        @line_graph_options = {
            width: 1280,
            height: 720,
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
