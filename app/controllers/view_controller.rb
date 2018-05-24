include ViewHelper
include ApplicationHelper
class ViewController < ApplicationController
  require "open-uri"
  require "csv"

  def all
    @stats_data = Rails.cache.read('stats_data')
    @circ_hash = Rails.cache.read('circ_weekly')
    @topten = Rails.cache.read("topten")
    @pubcomp_hash = Rails.cache.read('pubcomp_weekly')
    @wireless_hash = Rails.cache.read('wireless_weekly')
    @newusers_hash = Rails.cache.read('newusers_weekly')

    @loc = {}
    locations = {}

    Settings.locations.each do |l|
      if l.path_name == params[:location]
        @current_locations = [l]
        @loc = l
        @short_name = l.short_name
        @evergreen_name = l.evergreen_name
        break
      else
        @current_locations = Settings.locations
      end

    end

    display_legend = Settings.locations.size == 1 || !params[:location].nil? ? false : true

    if Settings.multi_location == true && params[:location].nil?
        @eg_locations = "total"
        stat_locations = "total"
    elsif Settings.multi_location == true && !params[:location].nil?
        @eg_locations = @loc.evergreen_name
        stat_locations = @loc.short_name
    else
        @eg_locations = Settings.system_shortname
        stat_locations = Settings.system_shortname
    end

    # Color definitions for pie/circle graphs
    chart_colors = [ "rgba(57,106,177,1)", "rgba(218,124,48,1)", "rgba(62,150,81,1)", "rgba(204,37,41,1)",
                     "rgba(107,76,154,1)", "rgba(83,81,84,1)", "rgba(146,36,40,1)", "rgba(148,139,61,1)" ]
    chart_halftones = [ "rgba(57,106,177,0.5)", "rgba(218,124,48,0.5)", "rgba(62,150,81,0.5)", "rgba(204,37,41,0.5)",
                        "rgba(107,76,154,0.5)", "rgba(83,81,84,0.5)", "rgba(146,36,40,0.5)", "rgba(148,139,61,0.5)" ]

    # Collection Size (box + graph)
    @stats_collection_size = 0
    stats_collection_size_graph_data = []
    stats_collection_size_graph_labels = []
    @stats_collection_size_books = 0
    @stats_collection_size_books_types = []
    @stats_audio_visual_materials = 0
    @stats_audio_visual_materials_types = []

    @stats_data["collection_size"][@eg_locations].each do |type, val|
      @stats_collection_size += val.to_i

      if type.include? "book"
        @stats_collection_size_books += val.to_i
        @stats_collection_size_books_types.push(type)
      end

      if (type.include?("movies") || type.include?("music") || type.include?("audiobooks"))
        @stats_audio_visual_materials += val.to_i
        @stats_audio_visual_materials_types.push(type)
      end

      stats_collection_size_graph_data.push(val)
      stats_collection_size_graph_labels.push(item_type_map(type))
    end

    # Circulation by Type (graph + box)
    stats_circ_by_type_graph_data = []
    stats_circ_by_type_graph_labels = []
    @stats_circ_by_type_books = 0
    @stats_circ_by_type_av = 0

    @stats_data["circ_by_type_12months"][@eg_locations].each do |type, val|
      stats_circ_by_type_graph_data.push(val)
      stats_circ_by_type_graph_labels.push(item_type_map(type))

      if type.include? "book"
        @stats_circ_by_type_books += val.to_i
      end

      if (type.include?("movies") || type.include?("music") || type.include?("audiobooks"))
        @stats_circ_by_type_av += val.to_i
      end

    end

    @circ_type_graph = {
      labels: stats_circ_by_type_graph_labels,
      datasets: [{
        data: stats_circ_by_type_graph_data,
        label: "Circulations",
        backgroundColor: chart_halftones,
        borderColor: chart_colors,
        hoverBackgroundColor: chart_colors,
      }]
    }

    @circ_type_graph_options = {
      responsive: true,
      maintainAspectRatio: false,
      legend: { display: false },
      animation: { duration: 0 },
    }

    # Computer sessions / users (box)
    @stats_computer_sessions = @stats_data["pubcomp_12months"][stat_locations][:sessions]
    @stats_computer_users = @stats_data["pubcomp_12months"][stat_locations][:users]

    # Items Circulated (box)
    @stats_items_circulated = 0

    @stats_data["circ_by_type_12months"][@eg_locations].each do |type, val|
      @stats_items_circulated += val.to_i
    end

    if Settings.include_whimsy == true
        # Questions Answered (box)
        @stats_questions_answered = @stats_data["soft_stat_questions_12months"]["total"]

        # Puppets Circulated (box)
        @stats_puppets_circulated = @stats_data["circ_by_type_12months"]["total"]["puppets"]

        # Users Registered (box)
        @stats_new_users = @stats_data["newusers_12months"]["total"]
    end

    # Collection Stats (table)
    @stats_collection_stats = @stats_data["collection_size"]
    @stats_copies_added = @stats_data["copies_added_12months"][@eg_locations]
    @stats_copies_withdrawn = @stats_data["copies_withdrawn_12months"][@eg_locations]

    # Weekly Circulation (graph)
    @circ_graph = {}
    @circ_graph[:labels] = @circ_hash['graphdates']
    @circ_graph[:datasets] = []

    @current_locations.each do |location|
      loc = {}
      fill = (@current_locations.first == location)? "origin" : "-1"

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
        pointStyle: 'rectRounded',
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
      legend: { display: display_legend },
      animation: { duration: 0 },
      responsive: true,
      maintainAspectRatio: false,
    }

    # Wireless Sessions (graph)
    @wireless_graph = {}
    @wireless_graph[:labels] = @wireless_hash['graphdates']
    @wireless_graph[:datasets] = []

    @current_locations.each do |location|
      loc = {}
      fill = (@current_locations.first == location)? "origin" : "-1"

      loc = {
        label: location.short_name,
        backgroundColor: location.background_color,
        borderColor: location.border_color,
        data: @wireless_hash[location.short_name],
        fill: fill,
        pointRadius: 2,
        pointHitRadius: 1,
        pointHoverRadius: 5,
        pointBorderWidth: 1,
        pointStyle: 'rectRounded',
      }

      @wireless_graph[:datasets].push(loc)
    end

    @wireless_graph_options = {
      width: 1200,
      height: 480,
      plugins: { filler: { propogate: true } },
      scales: {
        yAxes: [{ stacked: true }],
        xAxes: [{ type: 'time', time: { unit: 'month', displayFormats: { month: 'MMM YY' } }, distribution: 'series' }]
      },
      tooltips: { mode: 'index', axis: 'x', intersect: false },
      legend: { display: display_legend },
      animation: { duration: 0 },
      responsive: true,
      maintainAspectRatio: false,
    }

    # Public Computer Sessions (graph)
    @pubcomp_graph = {}
    @pubcomp_graph[:labels] = @pubcomp_hash['graphdates']
    @pubcomp_graph[:datasets] = []

    @current_locations.each do |location|
      loc = {}
      fill = (@current_locations.first == location)? "origin" : "-1"

      loc = {
        label: location.short_name,
        backgroundColor: location.background_color,
        borderColor: location.border_color,
        data: @pubcomp_hash['sessions'][location.pubcomp_name],
        fill: fill,
        pointRadius: 2,
        pointHitRadius: 1,
        pointHoverRadius: 5,
        pointBorderWidth: 1,
        pointStyle: 'rectRounded',
      }

      @pubcomp_graph[:datasets].push(loc)
    end

    @pubcomp_graph_options = {
      width: 1200,
      height: 480,
      plugins: { filler: { propogate: true } },
      scales: {
        yAxes: [{ stacked: true }],
        xAxes: [{ type: 'time', time: { unit: 'month', displayFormats: { month: 'MMM YY' } }, distribution: 'series' }]
      },
      tooltips: { mode: 'index', axis: 'x', intersect: false },
      legend: { display: display_legend },
      animation: { duration: 0 },
      responsive: true,
      maintainAspectRatio: false,
    }

    # New Users (graph)
    @newusers_graph = {}
    @newusers_graph[:labels] = @newusers_hash['graphdates']
    @newusers_graph[:datasets] = []

    @current_locations.each do |location|
      loc = {}
      fill = (@current_locations.first == location)? "origin" : "-1"

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
        pointStyle: 'rectRounded',
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
      legend: { display: display_legend },
      animation: { duration: 0 },
      responsive: true,
      maintainAspectRatio: false,
    }

    # Collection Distribution (graph)
    @collection_dist_graph = {
      labels: stats_collection_size_graph_labels,
      datasets: [{
        data: stats_collection_size_graph_data,
        label: "Percent",
        backgroundColor: chart_halftones,
        borderColor: chart_colors,
        hoverBackgroundColor: chart_colors,
      }]
    }

  end

  def about
    @graphs_updated = Rails.cache.read('graphs_updated')
    @lists_updated = Rails.cache.read('lists_updated')
    @stats_updated = Rails.cache.read('stats_updated')
  end

end
