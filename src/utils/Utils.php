<?php
namespace utils;

class Utils {

  function getAcronyms($s){
      if($s != null){
        $users['sebas932'] = 'SA';
        $users['AndresFVR'] = 'AV';
        $users['HermesJim'] = 'HJ';
        $users['mralmanzar'] = 'MA';
        $users['cgarcia9106'] = 'CG';
        $users['jhanzuro'] = 'JZ';
        $users['Grant-Lay'] = 'GL';
        $users['jurodca'] = 'JR';
        $users['htobon'] = 'HT';
        $users['kenjitm'] = 'KT';
        $users['anamp07'] = 'AP';
        $users['carios1usb'] = 'CR';
        $users['MargaritaRamirez'] = 'MR';

        $acronym = $users[$s];

        if ($acronym != null){
          return $acronym;
        }else{
          return $s;
        }
      }else{
        return "Not Defined";
      }

  }

  function getRandomColor(){
    $rand = array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
    return '#'.$rand[rand(0,15)].$rand[rand(0,15)].$rand[rand(0,15)].$rand[rand(0,15)].$rand[rand(0,15)].$rand[rand(0,15)];
  }


  function getLabelValue($arrayLabels, $string){
    foreach ($arrayLabels as $label) {
      if (strpos($label['name'], $string) !== false) {
        $labelValue = explode('-',$label['name'])[1];
        if((trim($labelValue) != "")){
          return $labelValue;
        }
      }
    }
    return "Not Defined";
  }

  function getArrayByKeyValue($array, $key, $value){
    foreach ($array as $element) {
      if ($element[$key] == $value) {
        return $element;
      }
    }
    return "Not Defined";
  }

}

?>
