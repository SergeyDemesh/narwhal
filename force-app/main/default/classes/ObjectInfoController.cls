public with sharing class ObjectInfoController {

    public String objectName{get; set;}
    public Boolean canRead{get; set;}
    public Boolean canCreate{get; set;}
    public Boolean canEdit{get; set;}
    public Boolean canDelete{get; set;}
    public List<WrappedFields> fields{get; set;}



    public void getObjectInfo() {
        List<String> objName = new List<String>();
        objName.add(objectName);
        Map<String, SObjectType> objects = Schema.getGlobalDescribe();

        try {
            System.debug(objectName);
            DescribeSObjectResult describe = objects.get(objectName).getDescribe();
            canRead = describe.isAccessible();
            canCreate = describe.isCreateable();
            canEdit = describe.isUpdateable();
            canDelete = describe.isDeletable();
            fields = new List<ObjectInfoController.WrappedFields>();
            for (SObjectField field :Schema.describeSObjects(objName)[0].fields.getMap().values()) {
                fields.add(new WrappedFields(field));
            }
        } catch (NullPointerException ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Object not found'));
//            throw new VisualforceException(ex.getMessage());
        }




    }

    public class WrappedFields {
        public String Name{get; set;}
        public Boolean Read{get; set;}
        public Boolean Edit{get; set;}

        public WrappedFields(SObjectField field) {
            Name = field.getDescribe().name;
            Read = field.getDescribe().isAccessible();
            Edit = field.getDescribe().isUpdateable();
        }
    }

}