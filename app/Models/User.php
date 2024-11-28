<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use App\Http\Traits\NotifiableTrait;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable
{
    use HasRoles;
    use HasApiTokens, HasFactory, Notifiable;

    protected $guard_name = 'sanctum';



    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $attributes = [
        'otp_secret' => null,
    ];

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);

        $this->attributes['otp_secret'] = rand(1000, 9999);
    }

    protected $fillable = [
        'username',
        'email',
        'password',
        'phone',
        'otp_secret',
        'wallet',
    ];

    public function roleName()
    {
        return sizeof($this->getRoleNames()) > 0 ? $this->getRoleNames()[0] : "client";
    }



    public function password() : Attribute
    {
        return Attribute::make(set: fn($val) => bcrypt($val));
    }

    public function otp_secret() : Attribute
    {
        return Attribute::make(set: fn() => rand(1000, 9999));
    }





    public function orders()
    {
        return $this->hasMany(orders::class,'user_id');
    }

    public function orders_items()
    {
        return $this->hasManyThrough(orders_items::class,orders::class,'user_id','order_id');
    }

    



    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    /*protected $casts = [
        'phone_verified_at' => 'datetime',
    ];*/
}
