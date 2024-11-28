<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SupportResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
          'id'=>$this->id,
          'user'=>UserResource::make($this->whenLoaded('user')),
          'hall'=>HallResource::make($this->whenLoaded('hall')),
          'info'=>$this->info,
          'created_at'=>$this->created_at->format('Y-m-d H:i:s')
        ];
    }
}
