<?php

namespace App\Providers;

use App\Services\Messages;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\ServiceProvider;

class EloquentBuilderServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        //
        Builder::macro('firstOrFailWithCustomError',function ($error){
            if($this->first() == null){
                return Messages::error($error);
            }
            return $this->first();
        });
        // fail when found a result
        Builder::macro('failWhenFoundResult',function ($error){
            if($this->first() != null){
                return Messages::error($error);
            }
            return true;
        });

        Builder::macro('updateOrFailWithCustomError',function ($updated,$error,$success = '' , $success_data = ''){
            if($success == ''){
                $success = __('messages.updated_successfully');
            }
            $data = $this->first();
            if($data == null){
                return Messages::error($error);
            }
            $this->update($updated);
            return Messages::success($success,$success_data);
        });

        Builder::macro('FailIfNotFound',function ($error){
            if($this->first() == null){
                return throw new \Exception($error);
            }
            return $this->first();

        });
    }
}
