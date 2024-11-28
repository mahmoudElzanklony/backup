<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderItemsResource extends JsonResource
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
          'service'=>ServiceResource::make($this->service),
          'is_cancelled'=>$this->is_cancelled,
          'file'=>'orders_files/'.$this->file,
          'price'=>$this->price,
          'paper_number'=>$this->paper_number,
          'copies_number'=>$this->copies_number,
          'created_at'=>$this->created_at->format('Y-m-d H:i:s'),
        ];
    }
}
