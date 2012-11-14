module.exports = function(grunt) {
    'use strict';

    grunt.loadNpmTasks('grunt-jasmine-node');
    grunt.loadNpmTasks('grunt-contrib-coffee');

    // Project configuration.
    grunt.initConfig({
        pkg: '<json:package.json>',
        jasmine_node: {
            projectRoot: "./spec",
            requirejs: false,
            forceExit: true,
            extensions: 'coffee',
            jUnit: {
                report: true,
                savePath : "./spec/reports/",
                useDotNotation: true,
                consolidate: true
            }
        },
        lint: {
            files: ['grunt.js', 'lib/scrape.js']
        },
        watch: {
            files: '<config:lint.files>',
            tasks: 'default'
        },
        coffee: {
            compile: {
                files: {
                    'lib/scrape.js': 'lib/scrape.coffee'
                }
            }
        },
        jshint: {
            options: {
                curly: true,
                eqeqeq: true,
                immed: true,
                latedef: true,
                newcap: true,
                noarg: true,
                sub: true,
                undef: true,
                boss: true,
                eqnull: true,
                node: true
            },
            globals: {
                exports: true
            }
        }
    });

    // Default task.
    grunt.registerTask('test', 'lint jasmine_node');
    grunt.registerTask('default', 'coffee test');
};
