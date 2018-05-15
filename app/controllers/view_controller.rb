require "open-uri"
require "csv"

class ViewController < ApplicationController

    def all
        @circ_hash = Rails.cache.read('circ_weekly')
        @circ_graph = Hash.new
        @circ_graph[:labels] = @circ_hash['graphdates']
        @circ_graph[:datasets] = Array.new

        Settings.locations.each do |location|
            loc = Hash.new
            fill = (Settings.locations.first == location)? "origin" : "-1"

            loc = {
                label: location.short_name,
                backgroundColor: location.background_color,
                borderColor: location.border_color,
                data: @circ_hash[location.evergreen_name],
                fill: fill,
                pointRadius: 2,
                pointHitRadius: 1,
                pointHoverRadius: 5,
                pointBorderWidth: 1,
                pointStyle: 'rectRounded'
            }

            @circ_graph[:datasets].push(loc)
        end

        @circ_graph_options = {
            width: 1200,
            height: 480,
            plugins: { filler: { propogate: true } },
            scales: {
                yAxes: [{ stacked: true }],
                xAxes: [{ type: 'time', time: { unit: 'month', displayFormats: { month: 'MMM YY' } }, distribution: 'series' }]
            },
            tooltips: { mode: 'index', axis: 'x', intersect: false },
            responsive: true,
            maintainAspectRatio: false
        }

        @newusers_hash = Rails.cache.read('newusers_weekly')
        @newusers_graph = Hash.new
        @newusers_graph[:labels] = @newusers_hash['graphdates']
        @newusers_graph[:datasets] = Array.new

        Settings.locations.each do |location|
            loc = Hash.new
            fill = (Settings.locations.first == location)? "origin" : "-1"

            loc = {
                label: location.short_name,
                backgroundColor: location.background_color,
                borderColor: location.border_color,
                data: @newusers_hash[location.evergreen_name],
                fill: fill,
                pointRadius: 2,
                pointHitRadius: 1,
                pointHoverRadius: 5,
                pointBorderWidth: 1,
                pointStyle: 'rectRounded'
            }

            @newusers_graph[:datasets].push(loc)
        end

        @newusers_graph_options = {
            width: 1200,
            height: 480,
            plugins: { filler: { propogate: true } },
            scales: {
                yAxes: [{ stacked: true }],
                xAxes: [{ type: 'time', time: { unit: 'month', displayFormats: { month: 'MMM YY' } }, distribution: 'series' }]
            },
            tooltips: { mode: 'index', axis: 'x', intersect: false },
            responsive: true,
            maintainAspectRatio: false
        }

        @collection_movement_graph = {
            labels: ["Book", "Children's Book", "Video", "Compact Disc", "Magazine", "Audiobook"],
            datasets: [
                {
                    label: "Additions",
                    data: [4788, 2242, 1417, 917, 2036, 437],
                    backgroundColor: "rgba(62,150,81,0.5)",
                    borderColor: "rgba(62,150,81,1)",
                    pointRadius: 3,
                    pointHitRadius: 8,
                    pointHoverRadius: 5,
                    pointBorderWidth: 1,
                    pointStyle: 'rectRounded',
                    fill: false,
                    radius: 6,
                },
                {
                    label: "Withdrawls",
                    data: [4319, 2484, 448, 687, 931, 715],
                    backgroundColor: "rgba(204,37,41,0.5)",
                    borderColor: "rgba(204,37,41,1)",
                    pointRadius: 3,
                    pointHitRadius: 8,
                    pointHoverRadius: 5,
                    pointBorderWidth: 1,
                    pointStyle: 'rectRounded',
                    fill: false,
                    radius: 6,
                }
            ]
        }
        @collection_movement_graph_options = {
            scale: {
                ticks: {
                    min: 0,
                    max: 5000,
                    stepSize: 1000
                }
            },
            tooltips: {
                mode: 'index',
                axis: 'x',
                intersect: true,
                displayColors: false
            }
        }

        @wireless_graph = {
            labels: ["January", "February", "June", "October"],
            datasets: [
                {
                    label: "Traverse City",
                    backgroundColor: "rgba(57,106,177,0.5)",
                    borderColor: "rgba(57,106,177,1)",
                    data: [1000, 1500, 1200, 1800],
                    fill: 'origin',
                    pointRadius: 2,
                    pointHitRadius: 1,
                    pointHoverRadius: 5,
                    pointBorderWidth: 1,
                    pointStyle: 'rectRounded',
                },
                {
                    label: "East Bay",
                    backgroundColor: "rgba(218,124,48,0.5)",
                    borderColor: "rgba(218,124,48,1)",
                    data: [3800, 3100, 2400, 2800],
                    fill: '-1',
                    pointRadius: 2,
                    pointHitRadius: 1,
                    pointHoverRadius: 5,
                    pointBorderWidth: 1,
                    pointStyle: 'rectRounded',
                },
                {
                    label: "Fife Lake",
                    backgroundColor: "rgba(62,150,81,0.5)",
                    borderColor: "rgba(62,150,81,1)",
                    data: [128, 256, 184, 204],
                    fill: '-1',
                    pointRadius: 2,
                    pointHitRadius: 1,
                    pointHoverRadius: 5,
                    pointBorderWidth: 1,
                    pointStyle: 'rectRounded',
                },
                {
                    label: "Kingsley",
                    backgroundColor: "rgba(204,37,41,0.5)",
                    borderColor: "rgba(204,37,41,1)",
                    data: [328, 542, 423, 593],
                    fill: '-1',
                    pointRadius: 2,
                    pointHitRadius: 1,
                    pointHoverRadius: 5,
                    pointBorderWidth: 1,
                    pointStyle: 'rectRounded',
                },
                {
                    label: "Interlochen",
                    backgroundColor: "rgba(83,81,84,0.5)",
                    borderColor: "rgba(83,81,84,1)",
                    data: [318, 233, 185, 423],
                    fill: '-1',
                    pointRadius: 2,
                    pointHitRadius: 1,
                    pointHoverRadius: 5,
                    pointBorderWidth: 1,
                    pointStyle: 'rectRounded',
                },
                {
                    label: "Peninsula",
                    backgroundColor: "rgba(107,76,154,0.5)",
                    borderColor: "rgba(107,76,154,1)",
                    data: [38, 23, 59, 29],
                    fill: '-1',
                    pointRadius: 2,
                    pointHitRadius: 1,
                    pointHoverRadius: 5,
                    pointBorderWidth: 1,
                    pointStyle: 'rectRounded',
                },
            ]
        }
        @wireless_graph_options = {
            width: 1200,
            height: 480,
            plugins: { filler: { propogate: true } },
            scales: { yAxes: [{ stacked: true }] },
            tooltips: { mode: 'index', axis: 'x', intersect: false },
            responsive: true,
            maintainAspectRatio: false
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

    def collection
    end

    def circulation
    end

    def wireless
    end

    def pubcomp
    end

    def visitors
    end

    def questions
    end

end
