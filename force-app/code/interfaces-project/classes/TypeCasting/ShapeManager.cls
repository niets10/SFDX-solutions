public with sharing class ShapeManager {
    
    public void getShape(String className){

        IShape shape = ShapeHandler.handleShapes(className);
        shape.getShape();        

    }

}
