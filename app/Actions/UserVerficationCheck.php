<?php

namespace App\Actions;

class UserVerficationCheck
{
    public static function check()
    {
        return auth()->user()->phone_verified_at != null;
    }
}
