<?php


namespace App\Actions;


use App\Models\images;

class ImageModalSave
{
    public static function make($id,$model_name,$image_file){
        images::query()->create([
            'imageable_id'=>$id,
            'imageable_type'=>'App\Models\\'.$model_name,
            'name'=>$image_file,
        ]);
        return true;
    }
}
