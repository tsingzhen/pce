PCEJSBuild = require('./pcejs_build')

module.exports = (grunt) ->
  pcejs = new PCEJSBuild(grunt)
  pcejs.loadConfig() # extend with saved config

  packagedir = pcejs.config.packagedir

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

  # Main tasks
  grunt.task.registerTask 'reset', 'Reset config to default', ->
    pcejs.initConfig() # discard loaded config, reset to defaults
    pcejs.saveConfig()

  grunt.task.registerTask 'target', 'Choose build target (macplus,ibmpc,atarist)', (target) ->
    pcejs.config.target = target
    pcejs.saveConfig()

  grunt.task.registerTask 'configure', 'Configure emulator build', (arch) ->
    if (arch is 'native')
      pcejs.config.emscripten = false
      pcejs.config.prefix = 'build-native/'
    if (arch is 'em')
      pcejs.config.emscripten = true
      pcejs.config.prefix = 'build/'

    pcejs.run(this.async(), './scripts/10-configure.sh')

    pcejs.saveConfig()

  grunt.task.registerTask 'make', 'Build emulator', ->
    pcejs.run(this.async(), './scripts/20-make.sh')

  grunt.task.registerTask 'clean', 'Clean source tree', (full) ->
    if full
      pcejs.run(this.async(), './scripts/a0-clean.sh')
    else
      pcejs.run(this.async(), 'make', ['clean'])
  grunt.task.registerTask 'afterbuild', 'Package build for web', (target) ->
    pcejs.config.target = target if target

    pcejs.run(this.async(), './scripts/30-afterbuild.sh')

  grunt.registerTask 'build', 'Configure, build and package for web', (target) ->
    pcejs.config.target = target if target

    if target is 'native'
      grunt.task.run.apply(grunt.task, [
        'configure:native',
        'make'
      ])
    else
      grunt.task.run.apply(grunt.task, [
        'configure:em',
        'make',
        'afterbuild:'+pcejs.config.target
      ])

  grunt.task.registerTask 'run', 'Run emulator', ->
    pcejs.run(this.async(), 'http-server', [packagedir])

    console.log('serving emulator at http://localhost:8080/')

  grunt.task.registerTask 'romdir', 'Set rom/config/data directory', (romdir) ->
    pcejs.run(this.async(), './scripts/a1-romdir.sh', [], PCEJS_ROMDIR: romdir)

  # Alias tasks
  grunt.registerTask('rebuild', [
    'make',
    'afterbuild'
  ])

  # Default task
  # grunt.registerTask('default', [])
