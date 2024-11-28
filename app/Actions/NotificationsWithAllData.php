<?php

namespace App\Actions;

use App\Models\Notifications;

class NotificationsWithAllData
{
    public function get()
    {
        /*return Notifications::query()->when(auth()->user()->role->name == 'client',function ($e){
            $e->with('')
        })*/
    }
}
