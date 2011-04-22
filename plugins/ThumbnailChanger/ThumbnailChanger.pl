package MT::Plugin::ThumbnailChanger;
use strict;
use warnings;
use base qw(MT::Plugin);
use vars qw($VERSION $SCHEMA_VERSION);

$VERSION = '0.0.2';
$SCHEMA_VERSION = '0.06';

my $plugin = MT::Plugin::ThumbnailChanger->new({
    id => 'thumbnailchanger',
    key => __PACKAGE__,
    name => 'Thumbnail Changer',
    version => $VERSION,
    description => '<__trans phrase="You can change the thumbnail of the list of blog.">',
    author_name => 'Tomohiro Okuwaki',
    author_link => 'http://www.tinybeans.net/blog/',
    plugin_link => 'http://www.tinybeans.net/blog/download/mt-plugin/thumbnail-changer.html',
    l10n_class => 'ThumbnailChanger::L10N',
    schema_version => $SCHEMA_VERSION,
});
MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
		object_types => {
			'blog' => {
				'thumbnail_url' => 'string(255)',
            },
		},
		callbacks => {
            'template_param.cfg_prefs' => '$thumbnailchanger::ThumbnailChanger::Plugin::cb_tmpl_param_cfg_prefs',
            'template_source.recent_websites' => '$thumbnailchanger::ThumbnailChanger::Plugin::cb_tmpl_source_recent_websites',
            'template_source.recent_blogs' => '$thumbnailchanger::ThumbnailChanger::Plugin::cb_tmpl_source_recent_blogs',
            'template_source.favorite_blogs' => '$thumbnailchanger::ThumbnailChanger::Plugin::cb_tmpl_source_favorite_blogs',
		},
        tags => {
            function => {
                'ThumbnailURL' => '$thumbnailchanger::ThumbnailChanger::Plugin::handle_thumbnail_url',
            },
        },
    });
}

1;
