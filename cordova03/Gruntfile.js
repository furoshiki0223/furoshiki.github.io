module.exports = function (g) {

	var pkg = g.file.readJSON('package.json');

	g.loadNpmTasks('grunt-contrib-coffee');
	g.loadNpmTasks('grunt-contrib-compass');
	g.loadNpmTasks('grunt-contrib-concat');
	g.loadNpmTasks('grunt-contrib-uglify');
	g.loadNpmTasks('grunt-contrib-cssmin');
	g.loadNpmTasks('grunt-contrib-watch');
	g.loadNpmTasks('grunt-contrib-connect');
	g.loadNpmTasks('grunt-open');

	var liveReloadPort = 35729;
    var lrSnippet = require('connect-livereload')({port: liveReloadPort});
    var mountFolder = function (connect, dir) {
        return connect.static(require('path').resolve(dir));
    };

	g.initConfig({
		coffee: {
			compile: {
				files: [{
					expand: true,
					cwd: 'js/coffee/',
					src: '**/*.coffee',
					dest: 'js/js/', ext: '.js'
				}]
			}
		},
		concat: {
			js: {
				src : 'js/js/*.js',
				dest: 'js/concat/leaping.js'
			}
		},
		uglify: {
			dist: {
				files: {
					'js/leaping-min.js': 'js/concat/leaping.js'
				}
			}
		},
		watch: {
            options: { livereload: liveReloadPort},
			files: [
				'*.html',
				'img/*.jpg','img/*.png','img/*.gif',
				'js/coffee/*.coffee'
			],
			tasks: ['coffee','concat','uglify']
		},
		connect: {
			options: {
				port: 9001,
				hostname : 'localhost'
			},
			livereload: {
				options: {
					middleware: function (connect) {
						return [ lrSnippet, mountFolder(connect, './') ];
					}
				}
			}
		},
        open: {
            server: {
                url: 'http://localhost:<%=connect.options.port%>'
            }
        }
	});

	g.registerTask('default',['connect:livereload','open','watch']);

};