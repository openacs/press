<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_press_item_revision">      
      <querytext>
    begin
    :1 := press_revision.new(
        title         => :article_title,
        description   => :article_abstract,
        mime_type     => :mime_type,
        text          => :txt,
        item_id       => :item_id,
        creation_user => :creation_user,
        creation_ip   => :creation_ip,
        package_id    => :package_id,
        publication_name => :publication_name,
        publication_link => :publication_link,
        publication_date => :publication_date,
        publication_date_desc => :publication_date_desc,
        article_link  => :article_link,
        article_pages => :article_pages,
        article_abstract_html_p => :html_p,
        approval_user => :approval_user,
        approval_date => :approval_date, 
        approval_ip   => :approval_ip,
        release_date  => :release_date,
        archive_date  => :archive_date,
        template_id   => :template_id,
        make_active_revision_p => :active_revision_p
    );
    end;
      </querytext>
</fullquery>

</queryset>
