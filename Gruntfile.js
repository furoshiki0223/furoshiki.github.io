module.exports = function (g) {

	var pkg = g.file.readJSON('package.json');

	g.loadNpmTasks('grunt-contrib-watch');
	g.loadNpmTasks('grunt-contrib-connect');
	g.loadNpmTasks('grunt-open');
	g.loadNpmTasks('grunt-contrib-htmlmin');

	var liveReloadPort = 55729;
    var lrSnippet = require('connect-livereload')({port: liveReloadPort});
    var mountFolder = function (connect, dir) {
        return connect.static(require('path').resolve(dir));
    };

	g.initConfig({
		watch: {
            options: { livereload: liveReloadPort},
			files: [
				'html_org/*.html'
			],
			tasks: ['htmlmin']
		},
        open: {
            server: {
                url: 'http://localhost:<%=connect.options.port%>'
            }
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
		htmlmin: {
            dist: {
				options: {
					removeRedundantAttributes: true,
					removeOptionalTags: true,
					removeComments: true,
					removeCommentsFromCDATA: true,
					removeCDATASectionsFromCDATA: true,
					collapseWhitespace: true,
					minifyJS : true,
					minifyCSS : true,
					minifyURLs : true,
				},
				expand: true,
				cwd: 'html_org/',
				src: '*.html',
				dest: '', ext: '.html'
			}
		}
	});

	g.registerTask('default',['connect:livereload','open','watch']);
	g.registerTask('build',['htmlmin']);

};