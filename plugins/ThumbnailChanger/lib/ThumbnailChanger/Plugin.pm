package ThumbnailChanger::Plugin;
use strict;
use warnings;
use MT::Blog;

sub cb_tmpl_param_cfg_prefs {
    my ($cb, $app, $param, $tmpl) = @_;
    return unless UNIVERSAL::isa($tmpl, 'MT::Template');
    
    # Ponter field
    my $pointer_node = $tmpl->getElementById('has-license');

    # Make new node
    my ($label, $innerHTML, $nodeset);
    my $static_path = $app->static_path;
    $label = '<__trans_section component="thumbnailchanger"><__trans phrase="Thumbnail"></__trans_section>URL';
    $innerHTML = $static_path . 'plugins/ThumbnailChanger/<input type="text" id="thumbnail_url" name="thumbnail_url" value="<mt:var name="thumbnail_url">" class="mt-edit-field" style="width: 15em;" />';
    $nodeset = $tmpl->createElement('app:setting', { 
        id => 'thumbnail',
        label => $label ,
        content_class => 'field-content-text',
        hint => '<__trans_section component="thumbnailchanger"><__trans phrase="You can change the thumbnail of the list of blog."></__trans_section>',
    });
    $nodeset->innerHTML($innerHTML);
    $tmpl->insertBefore($nodeset, $pointer_node); 

}

sub _replace_website_thumb {
    my ($tmpl_ref) = @_;
    my $website_thumb = '<mt:var name="website_theme_thumb">';
    my $p_website_thumb = '<mt:var name="website_id" setvar="crt_id"><mt:ThumbnailURL blog_id="$crt_id" setvar="thumbnail"><mt:if name="thumbnail"><mt:var name="thumbnail"><mt:else><mt:var name="website_theme_thumb"></mt:if>';
    $$tmpl_ref =~ s!$website_thumb!$p_website_thumb!g;
}

sub _replace_blog_thumb {
    my ($tmpl_ref) = @_;
    my $blog_thumb = '<mt:var name="blog_theme_thumb">';
    my $p_blog_thumb = '<mt:var name="blog_id" setvar="crt_id"><mt:ThumbnailURL blog_id="$crt_id" setvar="thumbnail"><mt:if name="thumbnail"><mt:var name="thumbnail"><mt:else><mt:var name="blog_theme_thumb"></mt:if>';
    $$tmpl_ref =~ s!$blog_thumb!$p_blog_thumb!g;
}

sub cb_tmpl_source_recent_websites {
    my ($cb, $app, $tmpl_ref) = @_;
    &_replace_website_thumb($tmpl_ref);
}

sub cb_tmpl_source_recent_blogs {
    my ($cb, $app, $tmpl_ref) = @_;
    &_replace_blog_thumb($tmpl_ref);
}

sub cb_tmpl_source_favorite_blogs {
    my ($cb, $app, $tmpl_ref) = @_;
    &_replace_website_thumb($tmpl_ref);
    &_replace_blog_thumb($tmpl_ref);
}

sub handle_thumbnail_url {
    my ($ctx, $args) = @_;
    my $app = MT->instance();
   
    my $blog_id = $args->{blog_id};
    my $blog = MT::Blog->load({ id => $blog_id });
    my $static_path = $app->static_path;
    my $thumnail_url = $blog->thumbnail_url || '';
    if ($thumnail_url) {
        $thumnail_url =  $static_path . 'plugins/ThumbnailChanger/' . $thumnail_url;
    }
    return $thumnail_url;
}
1;
