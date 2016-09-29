function graphOutWeight(){
  // Make ajax call to find out all the measurement for weight

    // Put all data for weight in this collection = [{x: day number, y: weight},{}]
    var lineData = [{
      x: 0,  //start of program
      y: 250 //starting weight
    }, {
      x: 7, //first weigh in
      y: 200 //weight of first weigh in
    }, {
      x: 14, //second weigh in
      y: 190 //weight of second weigh in
    }, {
      x: 21,
      y: 175
    }, {
      x: 28,
      y: 170
    }, {
      x: 35,
      y: 175
    }];


    var vis = d3.select('#vis_weight'),
        WIDTH = 800,
        HEIGHT = 300,
        MARGINS = {
          top: 20,
          right: 20,
          bottom: 20,
          left: 50
        },
        xRange = d3.scale.linear().range([MARGINS.left, WIDTH - MARGINS.right]).domain([d3.min(lineData, function(d) {
          return d.x;
        }), d3.max(lineData, function(d) {
          return d.x;
        })]),
        yRange = d3.scale.linear().range([HEIGHT - MARGINS.top, MARGINS.bottom]).domain([d3.min(lineData, function(d) {
          return d.y;
        }), d3.max(lineData, function(d) {
          return d.y;
        })]),
        xAxis = d3.svg.axis()
          .scale(xRange)
          .tickSize(5)
          .tickSubdivide(true),
        yAxis = d3.svg.axis()
          .scale(yRange)
          .tickSize(5)
          .orient('left')
          .tickSubdivide(true);

    vis.append('svg:g')
      .attr('class', 'x axis')
      .attr('transform', 'translate(0,' + (HEIGHT - MARGINS.bottom) + ')')
      .call(xAxis);

    vis.append('svg:g')
      .attr('class', 'y axis')
      .attr('transform', 'translate(' + (MARGINS.left) + ',0)')
      .call(yAxis);


    var lineFunc = d3.svg.line()
      .x(function(d) {
        return xRange(d.x);
      })
      .y(function(d) {
        return yRange(d.y);
      })
      .interpolate('linear');

    vis.append('svg:path')
      .attr('d', lineFunc(lineData))
      .attr('stroke', 'blue')
      .attr('stroke-width', 2)
      .attr('fill', 'none');
}





function graphOutBodyFat(){
  // Make ajax call to find out all the measurement for weight

    // Put all data for weight in this collection
      var lineData = [{
      x: 0,
      y: 30.0
    }, {
      x: 7,
      y: 29
    }, {
      x: 14,
      y: 28
    }, {
      x: 21,
      y: 28
    }, {
      x: 28,
      y: 25
    }, {
      x: 35,
      y: 20
    }];


    var vis = d3.select('#vis_body_fat'),
        WIDTH = 800,
        HEIGHT = 300,
        MARGINS = {
          top: 20,
          right: 20,
          bottom: 20,
          left: 50
        },
        xRange = d3.scale.linear().range([MARGINS.left, WIDTH - MARGINS.right]).domain([d3.min(lineData, function(d) {
          return d.x;
        }), d3.max(lineData, function(d) {
          return d.x;
        })]),
        yRange = d3.scale.linear().range([HEIGHT - MARGINS.top, MARGINS.bottom]).domain([d3.min(lineData, function(d) {
          return d.y;
        }), d3.max(lineData, function(d) {
          return d.y;
        })]),
        xAxis = d3.svg.axis()
          .scale(xRange)
          .tickSize(5)
          .tickSubdivide(true),
        yAxis = d3.svg.axis()
          .scale(yRange)
          .tickSize(5)
          .orient('left')
          .tickSubdivide(true);

    vis.append('svg:g')
      .attr('class', 'x axis')
      .attr('transform', 'translate(0,' + (HEIGHT - MARGINS.bottom) + ')')
      .call(xAxis);

    vis.append('svg:g')
      .attr('class', 'y axis')
      .attr('transform', 'translate(' + (MARGINS.left) + ',0)')
      .call(yAxis);


    var lineFunc = d3.svg.line()
      .x(function(d) {
        return xRange(d.x);
      })
      .y(function(d) {
        return yRange(d.y);
      })
      .interpolate('linear');

    vis.append('svg:path')
      .attr('d', lineFunc(lineData))
      .attr('stroke', 'blue')
      .attr('stroke-width', 2)
      .attr('fill', 'none');
}

