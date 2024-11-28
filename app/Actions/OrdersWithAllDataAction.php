<?php

namespace App\Actions;

use App\Models\orders;

class OrdersWithAllDataAction
{
    public static function get()
    {
        return orders::query()->with(['coupon_order.coupon','statues','items','rate','payment'])
            ->when(auth()->user()->roleName() != 'client',fn($e)=> $e->with('user'))->orderBy('id','DESC');
    }
}
