/*------------------------------------------------------------
Author:         Minsait (Alvaro G & Diego M)
Company:        Minsait by Indra
Description:    Comprueba la validez de un documento de identidad
 
Test Class:     ValidarCIFNIENIF_test
History
<Date>          <Author>                            <Change Description>
19-Sep-2018     Minsait (Alvaro N & Diego M)         Version inicial
------------------------------------------------------------*/
public class SE_CNT_ValidarCIFNIENIF {
 
    private static final String letrasNif = 'TRWAGMYFPDXBNJZSQVHLCKE';
    private static final String letrasCif = 'ABCDEFGHJKLMNPQRSUVW';
    private static final String letrasNie = 'XYZ';
    private static final String digitoControlCif = 'ABEH';
    private static final String cifLetra = 'KPQS';
    private static final String letrasCifControl = 'JABCDEFGHI';
 
    /**
     * Valida un documento de identificación español (NIF, NIE o CIF)
     *
     * @param nif documento a validar
     * @return true si es válido, false si no lo es.
     **/
    public static boolean isvalido(String nif) {
        nif = nif.toUpperCase();
        String a = nif.substring(0, 1);
 
        if (letrasCif.contains(a)) {
            return isCifValido(nif);
        } else if (letrasNie.contains(a)) {
            return isNieValido(nif);
        } else {
            return isDniValido(nif);
        }
    }
 
    /**
     * Dado un DNI elimina el digito de control y devuelve el DNI con el digito correctamente calculado
     *
     * @param: DNI completo
     * @result: DNI completo (recalculado) 
     **/
    private static String calculaDni(String dni) {
        String str = completaCeros(dni, 8);
         
        if(str.length()==9){
            str=str.substring(0,dni.length()-1);
        }
        return str + calculaLetra(str);
    }
 
    /*
     * Dado un NIE elimina el digito de control y devuelve el NIE con el digito correctamente calculado
     *
     * @param: NIE completo
     * @result: NIE completo (recalculado) 
     */
    private static String calculaNie(String nie) {
        String str = null;
         
        if(nie.length()==9){
            nie=nie.substring(0, nie.length()-1);
        }
 
        if (nie.startsWith('X')) {
            str = nie.replace('X', '0');
        } else if (nie.startsWith('Y')) {
            str = nie.replace('Y', '1');
        } else if (nie.startsWith('Z')) {
            str = nie.replace('Z', '2');
        }
 
        return nie + calculaLetra(str);
    }
 
    /*
     * Realiza el cálculo para las posiciones impares del CIF
     * Multiplicar por 2 y sumar los dígitos del resultado.
     *
     * @param: (str) Digito CIF (impar)
     * @result: Valor calculado
     */
    private static Integer posicionImpar(String str) {
        Integer aux = Integer.valueOf(str);
        aux = aux * 2;
        aux = (aux / 10) + math.mod(aux, 10);       
         
        return aux;
    }
     
    /*
     * Comprueba que un DNI es válido
     *
     * @param: (str) DNI completo
     * @result: (bool) True si es correcto false si no
     */
    private static boolean isDniValido(String dni) {
        String aux = dni.substring(0, 8);
        aux = calculaDni(aux);
 
        return dni.equals(aux);
    }
 
    /*
     * Comprueba que un NIE es válido
     *
     * @param: (str) NIE completo
     * @result: (bool) True si es correcto false si no
     */   
    private static boolean isNieValido(String nie) {
        String aux = nie.substring(0, 8);
        aux = calculaNie(aux);
 
        return nie.equals(aux);
    }
 
    /*
     * Comprueba que un CIF es válido
     *
     * @param: (str) CIF completo
     * @result: (bool) True si es correcto false si no
     */    
    private static boolean isCifValido(String cif) {
        String str = cif.substring(1, 8);
        String cabecera = cif.substring(0, 1);
        String control = cif.substring(8, 9);
        Integer sumaPar = 0;
        Integer sumaImpar = 0;
        Integer sumaTotal;
 
        for (Integer i = 1; i < str.length(); i += 2) {
            Integer aux = Integer.valueOf('' + str.mid(i,1));
            sumaPar += aux;
        }
 
        for (Integer i = 0; i < str.length(); i += 2) {
            sumaImpar += posicionImpar('' + str.mid(i,1));
        }
 
        sumaTotal = sumaPar + sumaImpar;
        sumaTotal = 10 - math.mod(sumaTotal, 10);
         
         
        if(sumaTotal == 10){
            sumaTotal = 0;
        }
 
        if (cifLetra.contains(cabecera)) {
            // Control es letra
            return (control == letrasCifControl.mid(sumaTotal,1));           
        } else if(digitoControlCif.contains(cabecera)){
            // Control es numero
            return (control == ('' + sumaTotal));
        } else {
            // Control es numero o letra
            return ((control == '' + sumaTotal) || (control == letrasCifControl.mid(sumaTotal,1)));
        }
    }
 
    /*
     * Devuelve la letra de control correspondiente para NIE o NIF
     *
     * @param: (str) NIF sin control // NIE digito inicial sustituido y sin control
     * @result: (str) Letra correspondiente
     */   
    private static String calculaLetra(String aux) {
        Integer x = Integer.valueOf(aux);
        Integer y = math.mod(x, 23);
        return letrasNif.mid(y,1);
    }
     
    /*
     * Completa el NIF con 0 iniciales hasta completar la longitud indicada
     *
     * @param: (str) NIF completo
     * @param: (int) longitud
     * @result: (str) NIF completado con 0
     */ 
    private static String completaCeros(String str, Integer num) {
        while (str.length() < num) {
            str = '0' + str;
        }
        return str;
    }
}