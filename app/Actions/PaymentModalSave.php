<?php

namespace App\Actions;

use App\Models\payments;
use App\Models\taxes;

class PaymentModalSave
{
    public static function make($id,$model_name,$money,$type = 'visa'){
        payments::query()->create([
            'paymentable_id'=>$id,
            'paymentable_type'=>'App\Models\\'.$model_name,
            'money'=>$money,
            'tax'=>taxes::query()->first()->percentage ?? 0,
            'type'=>$type
        ]);
        return true;
    }
}
