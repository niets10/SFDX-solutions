public with sharing class ShapeHandler {
    
    public static IShape handleShapes(String className){

        IShape shape;
        Type t;

        switch on className {
            when 'Circle' {
                t = Type.forName('Circle');
            }
            when 'Rectangle' {
                t = Type.forName('Rectangle');
            }
            when 'Square' {
                t = Type.forName('Square');
            }
        }

        return (IShape) t.newInstance();


    }

}
