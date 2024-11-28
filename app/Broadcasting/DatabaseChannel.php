<?php

namespace App\Broadcasting;
use Illuminate\Notifications\Notification;
use Illuminate\Notifications\Channels\DatabaseChannel as DBO;
use App\Models\User;

class DatabaseChannel extends DBO
{
    /**
     * Create a new channel instance.
     */
    public function __construct()
    {
        //
    }

    /**
     * Authenticate the user's access to the channel.
     */
    public function join(User $user): array|bool
    {
        //
    }

    protected function buildPayload($notifiable, Notification $notification)
    {
        return [
            'id' => $notification->id,
            'type' => get_class($notification),
            'data' => ['data' => serialize($notification)],
            'read_at' => null,
            'serialized' => true
        ];
    }
}
