
Package.describe({
    summary: 'Style-query: JQuerified stylesheet library.',
    "version": "0.0.17",
    git: 'https://github.com/i4han/style-query.git',
    documentation: 'README.md'
});

Package.on_use( function (api) {
    // api.use('jquery@1.0.1');
    api.use('isaac:absurd@0.1.2');
    api.use('isaac:underscore2@0.5.93');
    api.add_files( 'style-query.js', 'client');
});
