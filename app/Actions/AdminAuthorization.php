<?php

namespace App\Actions;

use App\Models\User;

class AdminAuthorization
{
    public static function check()
    {
        return auth()->user()->roleName() != 'client';
    }
}
