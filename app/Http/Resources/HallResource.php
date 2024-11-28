<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class HallResource extends JsonResource
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
          'city'=>CityResource::make($this->whenLoaded('city')),
          'images'=>ImageResource::collection($this->whenLoaded('images')),
          'name'=>$this->name,
          'info'=>$this->info,
          'address'=>$this->address,
          'type'=>$this->type,
          'day_price'=>$this->day_price,
          'created_at'=>$this->created_at->format('Y-m-d H:i:s')
        ];
    }
}
