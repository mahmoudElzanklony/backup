<?php

namespace App\Providers;

use App\Http\patterns\strategy\Messages\EmailMessages;
use App\Http\patterns\strategy\Messages\MessagesInterface;
use App\Http\patterns\strategy\Messages\NotificationsMessages;
use App\Http\patterns\strategy\Messages\SMSMessages;
use App\Http\patterns\strategy\payment\PaymentInterface;
use App\Http\patterns\strategy\payment\VisaPayment;
use App\Http\patterns\strategy\payment\WalletPayment;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\ServiceProvider;
use function PHPUnit\Framework\matches;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // binding messages interface
        $this->app->bind(MessagesInterface::class,function ($app){
            return match(request('sending_type')) {
                'email' => new EmailMessages(),
                'sms' => new SMSMessages(),
                default => new NotificationsMessages()
            };
        });
        // binding payment interface
        $this->app->bind(PaymentInterface::class,function ($app){
            if(isset(request('payment')['type'])) {
                return match (request('payment')['type']) {
                    'wallet' => new WalletPayment(),
                    default => new VisaPayment(),
                    // default => new NotificationsMessages()
                };
            }
            return new VisaPayment();
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
        Schema::defaultStringLength(191);


    }
}
