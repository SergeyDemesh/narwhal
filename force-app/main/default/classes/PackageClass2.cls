global with sharing class PackageClass2 {

   

    public static Integer getFactorial(Integer num) {
        if (num < 0){
            throw new System.AssertException('Enter the number > 0 !!!');
        }
        if (num == 0){
            return 1;
        }

        return num * getFactorial(num - 1);
    }
}