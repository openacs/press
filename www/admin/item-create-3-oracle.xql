<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="press_folder_id">      
      <querytext>
      select content_item.get_id('press') from dual
      </querytext>
</fullquery>

<fullquery name="object_id">      
      <querytext>
      select acs_object_id_seq.nextval from dual
      </querytext>
</fullquery>

<fullquery name="datestring">      
      <querytext>
      select to_char(sysdate, 'YYYYMMDD') from dual
      </querytext>
</fullquery>

<fullquery name="create_press_item">      
      <querytext>
begin
  :1 := press.new(
    name                  => :name,
    publication_name      => :publication_name,
    publication_link      => :publication_link,
    publication_date      => :publication_date,
    publication_date_desc => :publication_date_desc,
    article_link          => :article_link,
    article_pages         => :article_pages,
    article_abstract_html_p => :html_p,
    approval_user => :approval_user,
    approval_date => :approval_date, 
    approval_ip   => :approval_ip,
    release_date  => :release_date,
    archive_date  => :archive_date,
    package_id    => :package_id,
    parent_id     => :parent_id,
    item_id       => :item_id,
    title         => :article_title,
    description   => :article_abstract,
    mime_type     => :mime_type,
    template_id   => :template_id,
    text          => :txt,
    is_live_p     => :live_revision_p,
    creation_date => :creation_date,
    creation_ip   => :creation_ip,
    creation_user => :creation_user
);
end;
      </querytext>
</fullquery>

</queryset>


