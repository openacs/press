<?xml version="1.0"?>

<queryset>

<fullquery name="revision_root">    
      <querytext>
   select item_id
     from cr_revisions
    where revision_id = :revision_id
      </querytext>
</fullquery>

</queryset>
