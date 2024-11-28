<?php

namespace App\Actions;

use App\Http\Enum\CouponsTypesEnum;
use App\Models\coupons;
use App\Models\orders_coupons;
use App\Services\Messages;
use Carbon\Carbon;

class ValidateCouponAction
{
    public static function validate($number)
    {
        $coupon = coupons::query()->where('serial','=',$number)->first();

        if($coupon != null){
            // coupon exists
            // check if it's expired
            if($coupon->expiration_at < now()){
                return Messages::error(__('errors.coupon_expired'));
            }else{
                // check if this coupon not exceed max_number_of_users that using it
                $coupons_number_used = orders_coupons::query()->where('coupon_id','=',$coupon->id)->count();

                if($coupon->max_number_of_users > $coupons_number_used){
                    // check if user use it before
                    $user_check_using = orders_coupons::query()
                        ->where('coupon_id','=',$coupon->id)
                        ->whereHas('order',function ($e){
                            $e->where('user_id','=',auth()->id());
                        })->count();
                    if($user_check_using > 0){
                        // user used this before
                        // check coupon max usage per user more than once
                        if($coupon->max_usage_per_user <= $user_check_using){
                            return Messages::error(__('errors.you_cant_use_this_coupon_again'));
                        }
                    }
                }else{
                    // this coupon reach to max number of users that using it
                    return Messages::error(__('errors.coupon_reach_max_number_of_users'));
                }
            }
        }else{
            return Messages::error(__('errors.coupon_not_exist'));
        }
        return $coupon;
    }

    public static function detectFinalPrice($price,$coupon)
    {
        $final = 0;
        $coupon_value = 0;
        if($price > $coupon->max_value){
            $coupon_value = $coupon->max_value;
            $final = $price - $coupon->max_value;
        }else{
            // detect if coupon discount if fixed value or percentage
            if($coupon->type == CouponsTypesEnum::percentage){
                $coupon_value = $price * $coupon->value / 100;
                $final = $price - $coupon_value;
            }else{
                $coupon_value = $coupon->value;
                $final = $price - $coupon->value;
            }
        }
        return [
            'coupon_value'=>$coupon_value,
            'final_price'=>$final
        ];
    }
}
