<?php

namespace App\Http\Resources;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NotificationResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $data = json_decode($this->data['data'],true);
        if(array_key_exists('sender',$this->data)) {
            $sender = json_decode($this->data['sender'], true);
        }
        return [
            'id'=>$this->id,
            'content'=>$data[app()->getLocale()],
            'read_at'=>$this->read_at != null ? $this->read_at->format('Y-m-d H:i:s') : null,
            'created_at'=>$this->created_at->format('Y-m-d H:i:s'),
            'sender'=>isset($sender) && $sender != null ?  UserResource::make(User::query()->find($sender)):null,
        ];
    }
}
